Return-Path: <linux-kernel-owner+w=401wt.eu-S1755325AbYJ3W7E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325AbYJ3W7E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 18:59:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753524AbYJ3W6y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 18:58:54 -0400
Received: from solo.fdn.fr ([80.67.169.19]:48441 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753022AbYJ3W6x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 18:58:53 -0400
Date: Thu, 30 Oct 2008 23:58:50 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: James Renton <jrenton@castel.com>
Cc: linux-kernel@vger.kernel.org, Joe Maldonado <jmaldonado@castel.com>
Subject: Re: sigqueue() losing signals
Message-ID: <20081030225850.GB5306@const.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	James Renton <jrenton@castel.com>, linux-kernel@vger.kernel.org,
	Joe Maldonado <jmaldonado@castel.com>
References: <10058ACA10EE3444BBBC5FCF84825F63417127@casmail.hq.castel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10058ACA10EE3444BBBC5FCF84825F63417127@casmail.hq.castel.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mmm, isn't that just because non-realtime signals can not stack?

Samuel
