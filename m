Return-Path: <linux-kernel-owner+w=401wt.eu-S1753452AbZJ1WGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452AbZJ1WGV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 18:06:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752711AbZJ1WGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 18:06:20 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46239 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753103AbZJ1WGU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 18:06:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 1/1] PM / Hibernate: add \n to load_image fail path
Date: Wed, 28 Oct 2009 23:08:17 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc5-rjw; KDE/4.3.1; x86_64; ; )
Cc: Jiri Slaby <jirislaby@gmail.com>, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
References: <4AD39FBA.6000509@gmail.com> <1255383530-6778-1-git-send-email-jirislaby@gmail.com> <20091013072841.GD18997@elf.ucw.cz>
In-Reply-To: <20091013072841.GD18997@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910282308.17595.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 October 2009, Pavel Machek wrote:
> On Mon 2009-10-12 23:38:50, Jiri Slaby wrote:
> > Finish a line by \n when load_image fails in the middle of loading.
> > 
> > Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> 
> ACK.

Applied to suspend-2.6/linux-next.

Thanks,
Rafael
