Return-Path: <linux-kernel-owner+w=401wt.eu-S1759599AbYFOQod@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759599AbYFOQod (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 12:44:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758481AbYFOQo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 12:44:26 -0400
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:64425 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758430AbYFOQo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 12:44:26 -0400
Date: Sun, 15 Jun 2008 17:44:22 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: linux-kernel@vger.kernel.org
Subject: path to speakup control variables?
Message-ID: <20080615164422.GS4770@implementation>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

The speakup module used to put of its control variables (e.g. speech
speed) in /proc/speakup/ . To better stick with common practice,
should that go to somewhere in /sys or in /proc/sys/speakup (though
it looked to me like non-mainstream modules can't go there because of
sysctl_check)?

Samuel
