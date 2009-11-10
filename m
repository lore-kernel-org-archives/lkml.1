Return-Path: <linux-kernel-owner+w=401wt.eu-S1753421AbZKJKFO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421AbZKJKFO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 05:05:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753359AbZKJKFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 05:05:13 -0500
Received: from mail-pz0-f188.google.com ([209.85.222.188]:40545 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939AbZKJKFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 05:05:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=xRCJfJ6NnImRAv4Y/uJuRjAB5h3ZjfCpBhfaiUTSEvnhD1jZzRJ7U7Hej5f+1Y0tai
         1GY39eKR+Y7bDgMtjOHraq15bpr9PkDj1GxcExskWw0tx6mqEIXUF96AKiqZTvg/4bNM
         SznhdCplPDy88VCL2P8pZMlqBKrLPvoNNqhlQ=
MIME-Version: 1.0
In-Reply-To: <20091110082340.319f1ad3@jbarnes-x200>
References: <4AF875D0.10602@kernel.org> <20091110082340.319f1ad3@jbarnes-x200>
Date: Tue, 10 Nov 2009 02:05:17 -0800
Message-ID: <86802c440911100205i14dcf69i99cb0ef6f76406d1@mail.gmail.com>
Subject: Re: pci_find_parent_resource patch
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Ingo Molnar <mingo@elte.hu>,
       Matthew Wilcox <matthew@wil.cx>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 10, 2009 at 12:23 AM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> I don't remember seeing it, is it for 2.6.32?

http://lkml.org/lkml/2009/8/7/352

YH
