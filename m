Return-Path: <linux-kernel-owner+w=401wt.eu-S1753861AbZI0Lg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861AbZI0Lg6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 07:36:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753823AbZI0Lg6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 07:36:58 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:50486 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753813AbZI0Lg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 07:36:58 -0400
Date: Sun, 27 Sep 2009 07:37:00 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: updated list of "bad" refs to CONFIG variables
Message-ID: <alpine.LFD.2.00.0909270733570.30042@localhost>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  and to go with the earlier wiki page, i've updated the page of
preprocessor tests of CONFIG variables that don't appear to even
exist:

http://www.crashcourse.ca/wiki/index.php/Badref_CONFIG_variables

  could be a number of reasons for those:

  1) simple typoes
  2) removal of CONFIG variable from Kconfig file while forgetting
     to delete the corresponding test(s) that check that variable
  3) adding new code without adding the corresponding Kconfig info

you get the idea.

rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Linux Consulting, Training and Annoying Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Twitter:                                       http://twitter.com/rpjday
========================================================================
