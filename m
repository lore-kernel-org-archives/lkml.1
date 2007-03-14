Return-Path: <linux-kernel-owner+w=401wt.eu-S1161115AbXCNLJE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161115AbXCNLJE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 07:09:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161123AbXCNLJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 07:09:04 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59259 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161115AbXCNLJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 07:09:03 -0400
Subject: Re: Clarification required about select vs wake_up race condition
From: Arjan van de Ven <arjan@infradead.org>
To: "Ravinandan Arakali (rarakali)" <rarakali@cisco.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <FA6FB5FA4DA6BF4386D129273B2E3EC30183A411@xmb-sjc-214.amer.cisco.com>
References: <FA6FB5FA4DA6BF4386D129273B2E3EC30183A411@xmb-sjc-214.amer.cisco.com>
Content-Type: text/plain
Organization: Intel International BV
Date: Wed, 14 Mar 2007 04:07:55 -0700
Message-Id: <1173870475.3538.4.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-12 at 12:44 -0700, Ravinandan Arakali (rarakali) wrote:
> Hi,
> I am facing following problem and was wondering if somebody could help
> me out.
> Our char driver(pretty much like all other char drivers) does a
> poll_wait() 


you forgot to include your (full) sourcecode or a pointer to that...


