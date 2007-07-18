Return-Path: <linux-kernel-owner+w=401wt.eu-S932546AbXGRPHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932546AbXGRPHb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 11:07:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756062AbXGRPHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 11:07:18 -0400
Received: from rv-out-0910.google.com ([209.85.198.187]:46629 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756056AbXGRPHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 11:07:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=on3NZ85aOBnxj43U2QgFGlUcSTc1ORpcvR5/Sk848N5v1lC9lgnqaCx0fwxDeDLjoSx3Qi1Zady5613rgS6swV8b2x1iRvqi3xqKDquzGX3hlvPauEZxPHuEyFgCjiSZS3woGTE4qFYuxt1zYuoKg8+o/CzHwvR+grXKhAkIDXY=
Subject: Re: VESAFB CUSTOM RESOLUTION
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Al Boldi <a1426z@gawab.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200707181752.29478.a1426z@gawab.com>
References: <200707181342.00647.a1426z@gawab.com>
	 <200707181645.01097.a1426z@gawab.com> <1184768426.4523.20.camel@daplas>
	 <200707181752.29478.a1426z@gawab.com>
Content-Type: text/plain
Date: Wed, 18 Jul 2007 23:07:07 +0800
Message-Id: <1184771227.4523.24.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-07-18 at 17:52 +0300, Al Boldi wrote:
> Antonino A. Daplas wrote:
> > On Wed, 2007-07-18 at 16:45 +0300, Al Boldi wrote:
> > > Antonino A. Daplas wrote:
> > > > On Wed, 2007-07-18 at 13:42 +0300, Al Boldi wrote:
> > > > > Geert Uytterhoeven wrote:
> > > > > > On Wed, 18 Jul 2007, Sasa Ostrouska wrote:
> > > > >

> What about the VBE 3.0 arbitrary vertical refresh rate thing?

This is not implemented by the video-vesa.c because it will require
complex calculations of mode timings (such as with GTF) to be done
before starting the kernel.  However, uvesafb probably does.

Tony

