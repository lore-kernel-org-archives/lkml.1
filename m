Return-Path: <linux-kernel-owner+w=401wt.eu-S1759482AbYFQVQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759482AbYFQVQl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 17:16:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759227AbYFQVQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 17:16:29 -0400
Received: from web52507.mail.re2.yahoo.com ([206.190.48.190]:33331 "HELO
	web52507.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759174AbYFQVQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 17:16:28 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Jun 2008 17:16:27 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Message-ID;
  b=nmX4Hh9nJWaJ0fdn14dC47jTyzcbn9nMLvKwF43Qmp0P6jJp4fJLJrCGhUYe+ydYugKunU50icvNBN9H5oiyA+PbAkyrTpXPp+/zlbw8TLHW4uMAPuQpjVRSsHgylMsbD8Z3fuWHjA/OAPf484JfF2HU2+zgiR0IkTuoqi7K34A=;
X-Mailer: YahooMailWebService/0.7.199
Date: Tue, 17 Jun 2008 14:09:47 -0700 (PDT)
From: Marc Perkel <mperkel@yahoo.com>
Reply-To: mperkel@yahoo.com
Subject: Re: AMD Quad Core clock problem?
To: Chris Snook <csnook@redhat.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4803AD83.4030807@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <734241.71474.qm@web52507.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was just wondering if anyone has ever fixed the problem with AMD quad core Phenom processors not being calibrated close enough so that NTPD can correct for it?



      
