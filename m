Return-Path: <linux-kernel-owner+w=401wt.eu-S1754795AbXIJBU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795AbXIJBU1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 21:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752730AbXIJBUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 21:20:19 -0400
Received: from quechua.inka.de ([193.197.184.2]:55823 "EHLO mail.inka.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752619AbXIJBUS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 21:20:18 -0400
From: Bernd Eckenfels <ecki@lina.inka.de>
To: linux-kernel@vger.kernel.org
Subject: Re: unfamiliar notation
Organization: Private Site running Debian GNU/Linux
In-Reply-To: <1189386541.7365.50.camel@Tachyon.home>
X-Newsgroups: ka.lists.linux.kernel
User-Agent: tin/1.7.8-20050315 ("Scalpay") (UNIX) (Linux/2.6.13.4 (i686))
Message-Id: <E1IUXwl-0001Kp-00@calista.eckenfels.net>
Date: Mon, 10 Sep 2007 03:20:15 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In article <1189386541.7365.50.camel@Tachyon.home> you wrote:
> What's the deal with the underscore and the parentheses surrounding the
> call to menu_get_help?

it is a macro from gettext, used to translate the string. Usually this
should only be used on string constants.

Gruss
Bernd
