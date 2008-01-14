Return-Path: <linux-kernel-owner+w=401wt.eu-S1755462AbYANVbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462AbYANVbU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 16:31:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752225AbYANVbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 16:31:07 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:45786 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbYANVbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 16:31:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VPjd6yzX1ibfQ21chEwaKGSRLixvCtcy4IOMpFIWq3jWS95JEu4fJu59uNbQz+jbUUg8cZ/i6EDlPwaD7LJj4xHkVAsn6yX8dmglHzVdXvQpGIjggBotBbUvpoSa6fjS4cadDPOyQES5Aq605xg41TFb093hW2OxKdhK4quCfrg=
Message-ID: <6101e8c40801141331n3cb66c04pc74ff07faf04c8fd@mail.gmail.com>
Date: Mon, 14 Jan 2008 22:31:03 +0100
From: "=?ISO-8859-1?Q?Oliver_Pinter_(Pint=E9r_Oliv=E9r)?=" 
	<oliver.pntr@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: [BUG] skge 0000:02:05: read data parity error
Cc: "Stephen Hemminger" <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org, gregkh@suse.de
In-Reply-To: <20080114210105.GG9847@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6101e8c40801141157j1ce7d3f0if2e4eb2344b6c844@mail.gmail.com>
	 <20080114125200.28cb4c69@deepthought>
	 <20080114210105.GG9847@does.not.exist>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think, it is a potential security breakpoint, when applications with
root permission its read, then a machine is freezed, or only i thin
it's?


-- 
Thanks,
Oliver
