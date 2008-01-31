Return-Path: <linux-kernel-owner+w=401wt.eu-S1760767AbYAaEHN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760767AbYAaEHN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 23:07:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754756AbYAaEHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 23:07:00 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:22937 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787AbYAaEG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 23:06:58 -0500
To: Joachim Fenkes <fenkes@de.ibm.com>
Cc: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>, "OF-EWG" <ewg@lists.openfabrics.org>,
       "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
Subject: Re: [PATCH] IB/ehca: Prevent sending UD packets to QP0
X-Message-Flag: Warning: May contain useful information
References: <200801241759.09065.fenkes@de.ibm.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Wed, 30 Jan 2008 20:06:53 -0800
In-Reply-To: <200801241759.09065.fenkes@de.ibm.com> (Joachim Fenkes's message of "Thu, 24 Jan 2008 17:59:08 +0100")
Message-ID: <adaabmmabaa.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 31 Jan 2008 04:06:54.0063 (UTC) FILETIME=[B6B9DFF0:01C863BE]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks, applied
