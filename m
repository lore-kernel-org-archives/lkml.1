Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755157Ab0BUJLy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 04:11:54 -0500
Received: from ganesha.gnumonks.org ([213.95.27.120]:52839 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755003Ab0BUJLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 04:11:36 -0500
Date: Sun, 21 Feb 2010 09:04:59 +0100
From: Harald Welte <laforge@gnumonks.org>
To: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] backlight: fix missing/incomplete registration
 failure handling
Message-ID: <20100221080459.GE6672@prithivi.gnumonks.org>
References: <20100221001049.2f63f5d6@neptune.home>
 <20100221002831.689bace8@neptune.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100221002831.689bace8@neptune.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 21, 2010 at 12:28:31AM +0100, Bruno Prémont wrote:
> Check newly registered backlight_device for error and properly
> return error to parent
> 
> Signed-off-by: Bruno Prémont <bonbons@linux-vserver.org>

Acked-by: Harald Welte <laforge@gnumonks.org>

(for panasonic-laptop.c)
-- 
- Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.org/
============================================================================
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)
