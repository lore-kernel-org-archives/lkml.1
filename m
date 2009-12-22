Return-Path: <linux-kernel-owner+w=401wt.eu-S1752839AbZLVDPO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839AbZLVDPO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 22:15:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752240AbZLVDPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 22:15:13 -0500
Received: from smtp132.rog.mail.re2.yahoo.com ([206.190.53.37]:45214 "HELO
	smtp132.rog.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751723AbZLVDPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 22:15:11 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Dec 2009 22:15:11 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=rogers.com;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=uv+RoaXfVqTib3mAa7NNU4yGYRmj0eisQEr7GJI0MrB5C6zJUA6z1zcmqxPhZMB0negIKNtEm0/cwCvCoWSZh7Of6uWUIwW+61tBa0aftGjG3PwzEIg6idWVUCF40bYiBzC051ssxLZNAOP23GG3tzJlHdRlXpzS5ybuTrj2J3c=  ;
X-Yahoo-SMTP: rZzhDImswBA_40COIyZI42.8nAz5YXic.zo1v550XQVtX7k-
X-YMail-OSG: hNY827IVM1kwlGEv5bAyNX3NOo6icAEcCbj1ggk3sq_bel0.bYbvluG.2FI4V2Xedw--
X-Yahoo-Newman-Property: ymail-3
From: Shawn Starr <shawn.starr@rogers.com>
To: Robert Hancock <hancockrwd@gmail.com>
Subject: Re: [2.6.33-rc1] System timer flooding bus on Lenovo Thinkpad W500 laptop in x86_64
Date: Mon, 21 Dec 2009 22:08:26 -0500
User-Agent: KMail/1.13.0 (Linux/2.6.33-rc1-custom-radeon; KDE/4.3.82; x86_64; svn-1062525; 2009-12-14)
Cc: linux-kernel@vger.kernel.org
References: <200912211312.52769.shawn.starr@rogers.com> <200912211958.52120.shawn.starr@rogers.com> <51f3faa70912211707s50604a09ya1997979bb2f9fa4@mail.gmail.com>
In-Reply-To: <51f3faa70912211707s50604a09ya1997979bb2f9fa4@mail.gmail.com>
MIME-Version: 1.0
Message-Id: <200912212208.26679.shawn.starr@rogers.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On December 21, 2009 08:07:33 pm Robert Hancock wrote:
> On Mon, Dec 21, 2009 at 6:58 PM, Shawn Starr <shawn.starr@rogers.com> wrote:
> > This is found in http://bugzilla.kernel.org/show_bug.cgi?id=14354.
> 
> Wrong bug number? That one seems unrelated.
> 
Sorry, I meant http://bugzilla.kernel.org/show_bug.cgi?id=14859

The other was the old EXT4 corruption issue which was fixed.
