Return-Path: <linux-kernel-owner+w=401wt.eu-S968485AbYD1XL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968485AbYD1XL2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 19:11:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966866AbYD1XAL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 19:00:11 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:9669 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966614AbYD1XAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 19:00:07 -0400
From: Roland Dreier <rdreier@cisco.com>
To: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>
Cc: general@lists.openfabrics.org, Roel Kluin <12o3l@tiscali.nl>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Christoph Raisch <RAISCH@de.ibm.com>
Subject: Re: IB/ehca: handle negative return value from ibmebus_request_irq() properly in ehca_create_eq()
References: <200804281847.44968.hnguyen@linux.vnet.ibm.com>
X-Message-Flag: Warning: May contain useful information
Date: Mon, 28 Apr 2008 16:00:04 -0700
In-Reply-To: <200804281847.44968.hnguyen@linux.vnet.ibm.com> (Hoang-Nam
	Nguyen's message of "Mon, 28 Apr 2008 18:47:44 +0200")
Message-ID: <ada4p9lzitn.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 28 Apr 2008 23:00:04.0633 (UTC) FILETIME=[989D8890:01C8A983]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks, applied
