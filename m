Return-Path: <linux-kernel-owner+w=401wt.eu-S1752584Ab0A1MTI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584Ab0A1MTI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 07:19:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752022Ab0A1MTG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 07:19:06 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:50187 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915Ab0A1MTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 07:19:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=l0PzKBR0xyXpei4KguR5s9pYo0KB0ChHigu7VV/KhhiOJrbS7QtTqw0OS/hXa5ryR7
         4U70tVuAXSk1tUOVbJ0sPkasPRKNGjToBdAwkEvkb1nKTLR376kFczobhUyrc7d03B4Y
         CkKJatszAN1WMEbJBI96Wg5wZ2OZ5twzqhrks=
Date: Thu, 28 Jan 2010 13:19:00 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Jan Kiszka <jan.kiszka@siemens.com>
Subject: Re: [Patch 0/2 v2] Improvements for hw_breakpoint_handler()
Message-ID: <20100128121857.GB5074@nowhere>
References: <20100128111347.GA13935@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100128111347.GA13935@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 28, 2010 at 04:43:47PM +0530, K.Prasad wrote:
> Hi Frederic,
>         Can you please pull the second version of the patch which perform
> the  following.



Ok, looks good. I'm queueing these.

Thanks Prasad!

