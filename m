Return-Path: <linux-kernel-owner+w=401wt.eu-S1756907AbYCTQXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907AbYCTQXd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 12:23:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753148AbYCTQXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 12:23:24 -0400
Received: from homer.mvista.com ([63.81.120.158]:13317 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752375AbYCTQXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 12:23:24 -0400
Subject: Re: preempt_disable() question
From: Daniel Walker <dwalker@mvista.com>
To: Rick Brown <rick.brown.3@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <7783925d0803181914n16b0a221l179cc350bc2f3f89@mail.gmail.com>
References: <7783925d0803181914n16b0a221l179cc350bc2f3f89@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 20 Mar 2008 09:23:19 -0700
Message-Id: <1206030199.10894.201.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-03-19 at 07:44 +0530, Rick Brown wrote:
> Hi,
> 
> I've asked this on kernel newbies before, but not enough responses.
> 
> Does preempt_disable() disable preemption on all the processors, or
> just the local processor?

Just the local processor.

Daniel

