Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1754134AbYLQDSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134AbYLQDSW (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 22:18:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752222AbYLQDSL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 22:18:11 -0500
Received: from mx1.redhat.com ([66.187.233.31]:41163 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751996AbYLQDSK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 22:18:10 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
X-Fcc: ~/Mail/linus
Cc: oleg@redhat.com, ebiederm@xmission.com, daniel@hozac.com,
        bastian@waldi.eu.org, xemul@openvz.org, containers@lists.osdl.org,
        linux-kernel@vger.kernel.org, sukadev@us.ibm.com
Subject: Re: [RFC][PATCH][v2] SEND_SIG_NOINFO: Masquerade si_pid when crossing
	pid-ns boundary
In-Reply-To: Sukadev Bhattiprolu's message of  Tuesday, 16 December 2008 18:04:35 -0800 <20081217020435.GA2866@us.ibm.com>
References: <20081217020435.GA2866@us.ibm.com>
X-Zippy-Says: My face is new, my license is expired, and I'm under a doctor's care!!!!
Message-Id: <20081217031718.D31E5FC3BC@magilla.sf.frob.com>
Date: Tue, 16 Dec 2008 19:17:18 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-By: Roland McGrath <roland@redhat.com>
