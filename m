Return-Path: <linux-kernel-owner+w=401wt.eu-S933788AbXBZHZS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933788AbXBZHZS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 02:25:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933793AbXBZHZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 02:25:17 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:14578 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933783AbXBZHZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 02:25:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=mV9WrJbDDIzYA7Icx7W9zYPL3ImrrcY6T5OiUWwR6To5eZCeb+Vf6J3Fl+y4gbJcEt4XgkqAyn/vZes/TpPS1uZS+0fAgfFzn4MqqDfJ3x90AK+T5Z6elXdWXU3mGV2OhcjLDLDETst8M1vz9AhtAt50ww8C2pLiqXErw/K/n9A=
Message-ID: <84144f020702252325j29da2819i50c99477cce89359@mail.gmail.com>
Date: Mon, 26 Feb 2007 09:25:13 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: Alan <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC/PATCH] revokeat/frevoke system calls V5
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, hch@lst.de
In-Reply-To: <20070226003307.6f38d2ee@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0701282200450.17167@sbz-30.cs.Helsinki.FI>
	 <20070226003307.6f38d2ee@lxorguk.ukuu.org.uk>
X-Google-Sender-Auth: 935ea1a97a43ae39
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

On 2/26/07, Alan <alan@lxorguk.ukuu.org.uk> wrote:
> Whats the status on this, I was suprised to see something so important
> just go dead ?

It's not dead. You can find the latest patches here:

http://www.cs.helsinki.fi/u/penberg/linux/revoke/patches/

and user-space tests here:

http://www.cs.helsinki.fi/u/penberg/linux/revoke/utils/

What they are lacking is review so I am not sure how to proceed with
the patches.

                                 Pekka
