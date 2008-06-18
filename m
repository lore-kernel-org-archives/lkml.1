Return-Path: <linux-kernel-owner+w=401wt.eu-S1756166AbYFRSj5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166AbYFRSj5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 14:39:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754426AbYFRSjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 14:39:48 -0400
Received: from visualserver.org ([84.242.66.126]:60485 "EHLO visualserver.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753440AbYFRSjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 14:39:47 -0400
Date: Wed, 18 Jun 2008 20:39:38 +0200 (CEST)
From: Soumyadip Das Mahapatra <kernelhacker@visualserver.org>
To: linux-kernel@vger.kernel.org
Subject: Significance Of sort() In include/linux/sort.h
Message-ID: <Pine.LNX.4.64.0806152126001.6721@visualserver.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-visualserver.org-MailScanner-Information: Please contact the ISP for more information
X-MailScanner-ID: 16CC42FB3D.2819E
X-visualserver.org-MailScanner: Found to be clean
X-visualserver.org-MailScanner-From: kernelhacker@visualserver.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everybody,
 	I dont understand what is the significance of keeping
include/linux/sort.h and lib/sort.c while i think there is
none using (#include<linux/sort.h>) it. Can anyone explaint it?

Thanks :-)
