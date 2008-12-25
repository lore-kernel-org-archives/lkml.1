Return-Path: <linux-kernel-owner+w=401wt.eu-S1752160AbYLYRNJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160AbYLYRNJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 12:13:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751668AbYLYRM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 12:12:56 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:38661 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614AbYLYRMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 12:12:55 -0500
Date: Thu, 25 Dec 2008 17:12:52 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: linux-kernel@vger.kernel.org, radeonhd@opensuse.org
Subject: Re: v2.6.28-rc9: No video with test_suspend=mem
Message-ID: <20081225171252.GA7180@srcf.ucam.org>
References: <1230128020.3455.16.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1230128020.3455.16.camel@localhost.localdomain>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wait for Radeon modesetting to land, at which point we should restore 
graphics state in-kernel.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
