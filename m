Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832Ab0BJG4d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 01:56:33 -0500
Received: from smtp103.sbc.mail.gq1.yahoo.com ([67.195.15.62]:35764 "HELO
	smtp103.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750914Ab0BJG4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 01:56:32 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=sA/4xGvsSME9pWiLwmKTgtTCUOrwFofz6kuOaBbEzSGQPHKDPNMH17FsAa+B9x58C0D917OyQT5PgtYgEMiAj+Z3aMX3fGjWJDSVNNmpDYAOttkq+bt3YUhYKZOnXUh30NqDFvebWFGvZVbchylS+QRkOWEvDYPlZWyTK2SbEQw=  ;
X-Yahoo-SMTP: 2V1ThQ.swBDh24fWwg9PZFuY7TTwFsTuVtXZ.8DKSgQ-
X-YMail-OSG: u9Y_82EVM1noJZtmpx0JgdEEHoiMKPsILV3bVDoVAGfJZGqkin0HSZ7eAU8ENieAWrbPuCCpTmVf_uuSMYYTxpajxn1W_5eDjy0_0vviXp_qnmFhgs.AWbTy0PFuLkqbL3j5tUNdjsrbt7v38.kME.IjdF9CLw7a3p0HjlmixjL4EXdoV4e7BO96ODWEhy_DtS0YQ56DBFj_m77meWuLGbaNoZbifnFtJ2lkY7VSdria6aN2axdY1jP87EbOX_eNx9wheJHdd5Qe0i6t7WQPU4kk49g1jqs8hkmVPWYNrBrrPMKghUQ8G3n_6xXBp5cpnWqv_BuJeSnPHxAK.gtrSP36vW7SBC06wg_WnPKQWq3Ko6OY1M.Kr68Gk5YO53u3wREKmqBZI_VT2Ycm3DpRQjvJ
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] usbnet: convert dev(dbg|err|warn|info) macros to usbnet_(dbg|err|warn|info)
Date: Tue, 9 Feb 2010 22:56:29 -0800
User-Agent: KMail/1.9.10
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, linux-usb@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Oliver Neukum <oliver@neukum.name>, Peter Korsgaard <jacmet@sunsite.dk>,
       Steve Glendinning <steve.glendinning@smsc.com>
References: <3d8577211d88cce1fb6f4c1b54c5aa413a1f325a.1265765892.git.joe@perches.com> <201002092153.22322.david-b@pacbell.net> <1265782578.20626.17.camel@Joe-Laptop.home>
In-Reply-To: <1265782578.20626.17.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201002092256.30175.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 February 2010, Joe Perches wrote:

> netdev_printk macros instead.
> 
> http://patchwork.ozlabs.org/patch/44955/

That'd make sense.  Had they existed way back when ...
they could have been used instead of custom stuff.

