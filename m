Return-Path: <linux-kernel-owner+w=401wt.eu-S1762972AbYCYWKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762972AbYCYWKy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 18:10:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757486AbYCYWKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 18:10:45 -0400
Received: from smtp7-g19.free.fr ([212.27.42.64]:59822 "EHLO smtp7-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754673AbYCYWKo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 18:10:44 -0400
X-Greylist: delayed 12399 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Mar 2008 18:10:44 EDT
Date: Tue, 25 Mar 2008 23:09:17 +0100
From: Emmanuel Florac <eflorac@intellique.com>
To: Chris Snook <csnook@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: RAID-1 performance under 2.4 and 2.6
Message-ID: <20080325230917.00d5d71f@galadriel.home>
In-Reply-To: <47E975F8.3000702@redhat.com>
References: <20080325194306.4ac71ff2@galadriel.home>
	<47E975F8.3000702@redhat.com>
Organization: Intellique
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.8.20; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Tue, 25 Mar 2008 18:00:24 -0400 vous écriviez:

> It means you shouldn't use dd as a benchmark.

Sure, however my application may behave similarly to dd, or worse, some
external entity I don't have control upon (read : an annoying
customer) may use dd as a benchmark and draw fallacious asumptions I
need to sort out :)

-- 
--------------------------------------------------
Emmanuel Florac               www.intellique.com   
--------------------------------------------------
