Return-Path: <linux-kernel-owner+w=401wt.eu-S1755049AbXJaFFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049AbXJaFFs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 01:05:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752751AbXJaFFj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 01:05:39 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:17482 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223AbXJaFFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 01:05:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=s09GqmMdXh8RmS1hJSILRNC10PPqJlsWq1O6t3B0zMrNb7HcXTbodt9K8otbAnPCCaJfcLtjL0xixftkXVtnBShaSEegjsA5i/pni9c9E9fhl/u64yfMjcMVEACk9rJwnKNUltllIJN8pZe2EFlSUOcKdwU6I7Ww1VuWkpF3RTA=
Message-ID: <c3d0340b0710302205i7129f78bq9a4af7744ee60b6d@mail.gmail.com>
Date: Tue, 30 Oct 2007 21:05:36 -0800
From: "Shawn Jin" <shawnxjin@gmail.com>
To: "Jeff Garzik" <jeff@garzik.org>
Subject: Re: Multiple MSI messages support
Cc: "Roland Dreier" <rdreier@cisco.com>, linux-kernel@vger.kernel.org
In-Reply-To: <4727FDC3.8010407@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c3d0340b0710301413r2607ee08x8b27c5bffa43f1c4@mail.gmail.com>
	 <4727AED2.6010908@garzik.org> <adaejfci5cz.fsf@cisco.com>
	 <4727FDC3.8010407@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Oct 30, 2007 8:00 PM, Jeff Garzik <jeff@garzik.org> wrote:
> Roland Dreier wrote:
> > Multiple interrupt messages are supported by Linux via MSI-X (which
>
> Absolutely, but the poster seemed to be talking about MSI, not MSI-X.

I guess Roland understood my intention. :-P

My interpretation of this statement is that you have to use MSIX if
multiple MSI messages are required on Linux.

-Shawn.
