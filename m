Return-Path: <linux-kernel-owner+w=401wt.eu-S932263AbXDMTpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932263AbXDMTpb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 15:45:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932514AbXDMTpb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 15:45:31 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:59720 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932263AbXDMTpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 15:45:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=q/d6OJQkobwJNuSQnbDCII70n6HUUhDYnsm7vTSzkWFUthCUJe/NogrV0TQfjA9NLpRQEV21457ReTl8aailmB36Mch+kLjJJmshUF9m35r2p361cOZ3fyy+yImDNhBpMr3H9Se9ifNrh18289Xc8JaY4n00PqSB8HCgNiPhcMY=
Message-ID: <d4757e600704131245j7a045fa7sb2bca8cb8370f6d0@mail.gmail.com>
Date: Fri, 13 Apr 2007 15:45:29 -0400
From: "Joe Kappus" <joecool1029@gmail.com>
To: "Thomas Meyer" <thomas@m3y3r.de>
Subject: Re: [BUG] unable to handle kernel paging request at virtual address 0800000e
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org
In-Reply-To: <4616CBF4.8020205@m3y3r.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4616CBF4.8020205@m3y3r.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I can confirm the same oops on 2.6.20-ck1 with pktcdvd either as
module or as built-in.

I can assume perhaps this is not so much an issue with the pktcdvd
driver as it is with the libata drivers and scsi.  Beats me, I'll
leave it up to you.
