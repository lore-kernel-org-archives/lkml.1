Return-Path: <linux-kernel-owner+w=401wt.eu-S1756091AbYDUKWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091AbYDUKWa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 06:22:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754547AbYDUKWG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 06:22:06 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:15756 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754233AbYDUKWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 06:22:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Nbwv9gyHAGjmMr9oEHkbPa78CvZpHeHtrYZ5I05ch0zC58hXg/0uvgi6yM8ruy7NBnR8VEQm0XzIlrrp9nWjcREIH3+y8OK240VbpcgVlENAj71kkXcvPBKaxIE6TcXDenuzM/w2gSCA0kw2RPmNYe3aza3fHjpgZ9wuSRffk88=
Message-ID: <e2e108260804210322x5cb1f421pc2ad550c4324b39a@mail.gmail.com>
Date: Mon, 21 Apr 2008 12:22:03 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: fox@crisp.demon.co.uk
Subject: Re: dtrace for linux
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <E1JnMJE-0001et-Mr@pr-webmail-2.demon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <E1JnMJE-0001et-Mr@pr-webmail-2.demon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 20, 2008 at 1:17 AM,  <fox@crisp.demon.co.uk> wrote:
>
>  I would like to announce that I am working on dtrace for Linux.
>  I have the userland dtrace binary compiled, along with the first
>  pre-pre-alpha dtracedrv.ko module loaded into my kernel.

This is great news. How will this dtrace implementation differ from
SystemTap (http://sourceware.org/systemtap/) ?

Bart.
