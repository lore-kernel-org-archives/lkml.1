Return-Path: <linux-kernel-owner+w=401wt.eu-S1753781AbYBELZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753781AbYBELZe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 06:25:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbYBELZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 06:25:06 -0500
Received: from s131.mittwaldmedien.de ([62.216.178.31]:26735 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbYBELZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 06:25:04 -0500
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-kernel@vger.kernel.org
Subject: Re: OOPS in sysctl.c
Date: Tue, 5 Feb 2008 12:24:56 +0100
User-Agent: KMail/1.9.7
References: <200802050845.58691.hs4233@mail.mn-solutions.de>
In-Reply-To: <200802050845.58691.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802051224.56413.hs4233@mail.mn-solutions.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I have an embedded target (PXA255 based) where I have a nice
> running kernel 2.6.15. Today I'm trying to get 2.6.24 running
> on it.

Whatever the problem is, sysfs works now flawlessly even after
a suspend/resume with v2.6.24-7284-g9ef9dc6.
