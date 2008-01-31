Return-Path: <linux-kernel-owner+w=401wt.eu-S933534AbYAaVz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933534AbYAaVz5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 16:55:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760372AbYAaVzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 16:55:49 -0500
Received: from ara.aytolacoruna.es ([91.117.124.165]:59217 "EHLO
	mx.aytolacoruna.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759629AbYAaVzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 16:55:49 -0500
Date: Thu, 31 Jan 2008 22:55:41 +0100
From: Santiago Garcia Mantinan <manty@manty.net>
To: linux-kernel@vger.kernel.org
Subject: Re: dl2k stopped working on 2.6.24
Message-ID: <20080131215541.GA22018@dis.manty.net>
References: <20080125211153.GA10203@dis.manty.net> <20080128233334.GA14326@dis.manty.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080128233334.GA14326@dis.manty.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As I didn't get any ideas on what to do to help find the problem with the
dl2k driver, I'm doing some tests to get to know what has broken it.

I have today compiled dl2k from git, the version with the 2007-12-23 patches
from Al Viro: dl2k endianness fixes (.24 fodder?) Right before the Al Viro
patches. This seems to be working perfectly on my system.

I'm wondering if I can apply the patches by Al Viro one by one to know which
one broke it.

Regards...
-- 
Manty/BestiaTester -> http://manty.net
