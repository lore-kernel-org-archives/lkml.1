Return-Path: <linux-kernel-owner+w=401wt.eu-S1756244AbZBSQwr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244AbZBSQwr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 11:52:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752292AbZBSQwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 11:52:38 -0500
Received: from web110616.mail.gq1.yahoo.com ([67.195.13.207]:33018 "HELO
	web110616.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752640AbZBSQwh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 11:52:37 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=ss43wKdobCVJ9S0+iMPjETSK95yTUuzWp1tzwiOZSuYNktS5o1Cb9zpGCXYqIlPB4cei68D9kVR4A8VBJCwpHwa7hYtUfOfenNGHEieMAyWybpuWqMpR1/xrnOQ0vaMyCR3UgVa5ZbEIGXfkDrBmzoE322MfKTiyo8I5GCWldEs=;
X-YMail-OSG: m.zOgtsVM1lIbW46KttFouZ1pjeGOhUUbwpn8wkbcqhwm2.MUKJJin9UoJTdYiR0LEMeqyrFI5lwLCOVzNEtFVwUa0CxaPejnWi8yFkyO4i4ifLqdi8uDVq0O1OFPDOFTN7UHXpQHfFbkzi7B5mBjpMdi9HzYS9lTPbRj84I4bW0sJHwBcAY7y2oFe0x_TpXwGx_iTZFwk_K4iB1y8hJWCRwPtS1ASyyCr50710-
X-Mailer: YahooMailRC/1155.45 YahooMailWebService/0.7.260.1
References: <Pine.LNX.4.44L0.0902191002160.3012-100000@iolanthe.rowland.org>
Date: Thu, 19 Feb 2009 08:52:36 -0800 (PST)
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: [SCSI][REGRESSION][BISECTED] Disk errors loop forever in 2.6.29
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-kernel@vger.kernel.org,
       James Bottomley <James.Bottomley@HansenPartnership.com>, rjw@sisk.pl,
       Ingo Molnar <mingo@elte.hu>, linux-scsi@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Message-ID: <404514.58700.qm@web110616.mail.gq1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Alan Stern <stern@rowland.harvard.edu>
>
> On Thu, 19 Feb 2009, Sitsofe Wheeler wrote:
> 
> > Hi,
> > 
> > There appears to be a regression from 2.6.28 in how disk errors are
> > handled in 2.6.29rc5 - rather than trying and eventually giving up, it
> > appears to try (and report) forever. 
> 
> See this thread and patch:
> 
>     http://marc.info/?l=linux-kernel&m=123490148422684&w=2

The patch there (actually I downloaded it from http://patchwork.kernel.org/patch/7989/ )
did not make any diference. I fear my disk will soon have torn itself to bits but until then I
can trigger the error at will so I can test any patches that are suggested...



      
