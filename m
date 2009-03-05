Return-Path: <linux-kernel-owner+w=401wt.eu-S1756382AbZCESXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756382AbZCESXg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 13:23:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751895AbZCESX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 13:23:29 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:41045 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751444AbZCESX3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 13:23:29 -0500
From: Dan Smith <danms@us.ibm.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Oren Laadan <orenl@cs.columbia.edu>, Dave Hansen <haveblue@us.ibm.com>,
       Linux Containers <containers@lists.osdl.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] checkpoint: define pid==0 as self-checkpoint
References: <20090305174951.GA9782@us.ibm.com>
Date: Thu, 05 Mar 2009 10:23:24 -0800
In-Reply-To: <20090305174951.GA9782@us.ibm.com> (Serge E. Hallyn's message of
	"Thu, 5 Mar 2009 11:49:51 -0600")
Message-ID: <87hc27vnfn.fsf@caffeine.danplanet.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SH> Define pid=0 when calling sys_checkpoint as asking for a
SH> self-checkpoint.

Works for me (of course).

-- 
Dan Smith
IBM Linux Technology Center
email: danms@us.ibm.com

