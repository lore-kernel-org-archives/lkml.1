Return-Path: <linux-kernel-owner+w=401wt.eu-S1753854AbZI2TYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854AbZI2TYc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 15:24:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753607AbZI2TYb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 15:24:31 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:40956 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753494AbZI2TYb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 15:24:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=IH7t6rIg+fwyRHuBNiwN1LZVER4lujRF4932lRJNxv3ynSiI4eWBZHfSYUhVdHFd5A
         Y1jUfxewImCktozTt5n/IvTwuNyrtRu0gyovfjcTHglQUDlErD0pwtW85x/vdWbKoY3A
         DyB45VQTQk1rbp5Z9H4SRO1EPq56dBmJ0F1tU=
From: Volker Armin Hemmann <volkerarmin@googlemail.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: amd64 + mtrr: only 3.1gb of 8gb are covered, kernel 2.6.30 and earlier.
Date: Tue, 29 Sep 2009 21:24:29 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31.1r4; KDE/4.3.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <200908211814.56800.volkerarmin@googlemail.com> <200909291932.17282.volkerarmin@googlemail.com> <86802c440909291223n717894e3xdcd5ad4cdc8a6d28@mail.gmail.com>
In-Reply-To: <86802c440909291223n717894e3xdcd5ad4cdc8a6d28@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <200909292124.29796.volkerarmin@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dienstag 29 September 2009, Yinghai Lu wrote:
> On Tue, Sep 29, 2009 at 10:32 AM, Volker Armin Hemmann
> 
> <volkerarmin@googlemail.com> wrote:
> > On Sonntag 20 September 2009, Yinghai Lu wrote:
> >> your looks ok, because you got new CPU, and HW will set WB for [4G,
> >> TOM2)
> >
> > so the memory beyond 4gb is covered but the coverage is not shown in
> > /proc/mtrr?
> 
> right.
> 
> YH
> 

ok,
 thank you

Glück Auf,
Volker
