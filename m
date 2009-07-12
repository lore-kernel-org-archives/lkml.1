Return-Path: <linux-kernel-owner+w=401wt.eu-S1754038AbZGLU6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038AbZGLU6m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 16:58:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751853AbZGLU6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 16:58:35 -0400
Received: from mail-gx0-f215.google.com ([209.85.217.215]:39424 "EHLO
	mail-gx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090AbZGLU6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 16:58:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=v30nMp87jj15adEmFOLs/bE1/JGFnh6Xuf/lAMywhRmADhtQK/hNKjUAEmmCIJRmn0
         dySXhgACoyAxOumJFvnhVzzuqotHMIMSajEs6Uh2n7bRewzmnU0mA/TWSdXNtuHU4IIp
         N+L/lGAIGGikGKl+H7BN6Q4GW0vr8i5oFFDuQ=
MIME-Version: 1.0
In-Reply-To: <200907122221.46233.rjw@sisk.pl>
References: <86802c440907120117g7e9a5f41o915c4aefa49788dc@mail.gmail.com>
	 <200907122221.46233.rjw@sisk.pl>
Date: Sun, 12 Jul 2009 13:58:34 -0700
Message-ID: <86802c440907121358r4604913ci9793b656aff6e3df@mail.gmail.com>
Subject: Re: e1000e with kexec
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jesse Brandeburg <jesse.brandeburg@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 12, 2009 at 1:21 PM, Rafael J. Wysocki<rjw@sisk.pl> wrote:
> On Sunday 12 July 2009, Yinghai Lu wrote:
>> e1000e in second kernel doesn't work again.
>
> Which version is the first one, which version is the second one?

the same. current tree.

YH
