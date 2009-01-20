Return-Path: <linux-kernel-owner+w=401wt.eu-S1759921AbZATPjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759921AbZATPjU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 10:39:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754589AbZATPjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 10:39:11 -0500
Received: from mu-out-0910.google.com ([209.85.134.186]:4563 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902AbZATPjK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 10:39:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=M9WaaORY0KwfUyqa5GCZHy09uLImMXPfsNmqQCcj9Fr54o6EER1ZqqkRZhikimZISm
         j9AUAO8GoruYUh6TBd9llu3eL/D5WlrDFdmqqWJdtYNyC1IjGDqllPdZnSrDBG5rkaxp
         sRCe8s8XvpwbKmZj6x7I5szN5A3zqukCMVcKQ=
Date: Tue, 20 Jan 2009 16:30:28 +0100
From: Diego Calleja <diegocg@gmail.com>
To: Valdis.Kletnieks@vt.edu
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: Faulty seagate drives, are going to be blacklisted?
Message-ID: <20090120163028.63efeb1a@diego-desktop>
In-Reply-To: <85346.1232422345@turing-police.cc.vt.edu>
References: <20090120002923.065f24ca@diego-desktop>
	<85346.1232422345@turing-police.cc.vt.edu>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Mon, 19 Jan 2009 22:32:25 -0500, Valdis.Kletnieks@vt.edu escribió:

> The $64 question is, of course: What exactly should the operating system
> *do* if it detects one of these drives?  Prohibit it from bricking later
> by essentially bricking it *now*?   What if the drive already has a lot of
> production data on it?

Yeah, that's why I asked. Now that I think about it, it should probably be
the HAL people who should add one of those desktop "bubbles" warning the
users about the possible failure (they already do it for faulty batteries)
