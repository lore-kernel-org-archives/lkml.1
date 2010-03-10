Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932436Ab0CJQaq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 11:30:46 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48488 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756841Ab0CJQap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 11:30:45 -0500
Date: Wed, 10 Mar 2010 11:22:44 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Anyone using ray_cs wireless driver?
Message-ID: <20100310162243.GA3093@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm just curious to know if anyone is using ray_cs (even occasionally
and/or just for testing)?  Does anyone even have the hardware?

AFAICT ray_cs hasn't seen any changes that were not either part of a
tree-wide API change, the result of some static analysis tool run, the
result of some random code audit by Alan Cox or Al Viro, or something
else along those lines since before 2.6.12-rc2 (i.e. during the entire
history of git).

The driver may still work perfectly fine, or it might not -- I have
no way of knowing.  As it stands, I'm inclined to believe that it is
at best a drag on code maintenance resources and at worst a broken
and useless code appendage.

So, anyone using it?  At the very least, can anyone try it?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
