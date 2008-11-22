Return-Path: <linux-kernel-owner+w=401wt.eu-S1757611AbYKVLZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757611AbYKVLZ2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 06:25:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756867AbYKVLZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 06:25:20 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:42485 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756206AbYKVLZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 06:25:20 -0500
Date: Sat, 22 Nov 2008 12:24:45 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Werner Almesberger <werner@openmoko.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remove bashisms from scripts/extract-ikconfig
Message-ID: <20081122112445.GA24130@uranus.ravnborg.org>
References: <20081112183935.GA8443@almesberger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081112183935.GA8443@almesberger.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2008 at 04:39:35PM -0200, Werner Almesberger wrote:
> unbashify-extract-ikconfig.patch
> 
> scripts/extract-ikconfig contains a lot of gratuituous bashisms,
> which make it fail if /bin/sh isn't bash. This patch replaces them
> with regular Bourne shell constructs.
> 
> Signed-off-by: Werner Almesberger <werner@openmoko.org>

Applied to kbuild-next with Randy's ack.

	Sam
