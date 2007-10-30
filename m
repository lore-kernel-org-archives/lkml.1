Return-Path: <linux-kernel-owner+w=401wt.eu-S1757935AbXJ3WAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757935AbXJ3WAh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 18:00:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752740AbXJ3WA2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 18:00:28 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33224 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752499AbXJ3WA0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 18:00:26 -0400
Date: Tue, 30 Oct 2007 15:00:43 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: Norbert Preining <preining@logic.at>
Cc: linux-kernel@vger.kernel.org,
       USB development list <linux-usb-devel@lists.sourceforge.net>,
       zaitcev@redhat.com
Subject: Re: Huawei E220 and usb storage
Message-Id: <20071030150043.0ac65133.zaitcev@redhat.com>
In-Reply-To: <20071030190945.GC32153@gamma.logic.tuwien.ac.at>
References: <20071030190945.GC32153@gamma.logic.tuwien.ac.at>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Oct 2007 20:09:45 +0100, Norbert Preining <preining@logic.at> wrote:

> Is this a regression from 2.6.20, or is it supposed to work?

Please post your /proc/bus/usb/devices. Maybe it just fails to match.

-- Pete
