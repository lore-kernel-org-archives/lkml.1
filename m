Return-Path: <linux-kernel-owner+w=401wt.eu-S1754657AbZLUOh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657AbZLUOh2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 09:37:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753321AbZLUOh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 09:37:28 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:63353 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247AbZLUOh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 09:37:27 -0500
MIME-Version: 1.0
In-Reply-To: <cc557aab0912210537pdc076e7p5c90303fb6a32b66@mail.gmail.com>
References: <20091211212642.GA6624@kroah.com> <1260570289-6997-4-git-send-email-gregkh@suse.de> 
	<cc557aab0912210537pdc076e7p5c90303fb6a32b66@mail.gmail.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Mon, 21 Dec 2009 15:37:10 +0100
Message-ID: <ac3eb2510912210637n629ec609vf838a8b572867ffa@mail.gmail.com>
Subject: Re: [PATCH 04/27] Driver core: devtmpfs: prevent concurrent 
	subdirectory creation and removal
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 21, 2009 at 14:37, Kirill A. Shutemov <kirill@shutemov.name> wrote:
> v2.6.33-rc1-96-gdd59f6c:
> I guess it can be related to this commit.

The fix is already pending here:
  http://patchwork.kernel.org/patch/68337/

Thanks,
Kay
