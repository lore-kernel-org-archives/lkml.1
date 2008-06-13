Return-Path: <linux-kernel-owner+w=401wt.eu-S1752037AbYFMSVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037AbYFMSVf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 14:21:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751955AbYFMSV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 14:21:26 -0400
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:27367 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751678AbYFMSVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 14:21:23 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=tKmTmW2Ah3CoV8FJtlkhtKfiDbgqkqfOtNieEHTvl27sThwyPPNuXXEMBO2iFGPRtBeMnmuR18GqA6Ubr91Y0l9S01L0diNEdDBy65yd7VDFOtfmjpkUxZETsqaWLmZ2ysK7M/d+dhSGM1Dg0fuxqESZI5QqI5TFpKX9M0W41GA=  ;
X-YMail-OSG: vqeHC88VM1mImMvKedwFAe68zNmbNsoiVThR0L2iZbraOlzg6OXBmE3Iv3.G9DdRruTfLYBIJXaSPZ8hnhwC2BUIPjY1XKnvFXJgWg3W6mbXlAH68uEUcd7f9jBgPy7WwRA-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [RESEND #3/patch 2.6.26-rc6] net/enc28j60: low power mode
Date: Fri, 13 Jun 2008 11:21:21 -0700
User-Agent: KMail/1.9.9
Cc: netdev@vger.kernel.org, Claudio Lanconelli <lanconelli.claudio@eptar.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200806122138.06674.david-b@pacbell.net> <485240A8.5070802@garzik.org>
In-Reply-To: <485240A8.5070802@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806131121.21346.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 June 2008, Jeff Garzik wrote:
> I've put these two into my queue, so they are definitely in process now.

Thanks..


> For netdev patches it helps to CC me, since not every patch sent solely 
> to netdev@ is a to-be-applied patch, and might be missed -- or quite 
> often, assumed to be a patch that warrants discussion.

Ah.  I was more used to the convention that all patches should go to
the relevant mailing list (or LKML), and were assumed to be ready to
merge unless they were flagged as "RFC" or the relevant maintainer(s)
issued a NAK or other negative feedback.  When there was an ack or
signoff from the driver maintainer, it was ready to go.

- Dave

