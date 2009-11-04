Return-Path: <linux-kernel-owner+w=401wt.eu-S1757177AbZKDQU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757177AbZKDQU0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 11:20:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756864AbZKDQUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 11:20:25 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:37342 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756258AbZKDQUZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 11:20:25 -0500
Subject: Re: [RFC] Mount point suggestions for cgroup
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: balbir@linux.vnet.ibm.com, Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       containers@lists.linux-foundation.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Bharata B Rao <bharata.rao@in.ibm.com>,
       libcg-devel <libcg-devel@lists.sourceforge.net>,
       "menage@google.com" <menage@google.com>,
       Jan Safranek <jsafrane@redhat.com>
In-Reply-To: <20091104161142.GA8825@us.ibm.com>
References: <20091104063005.GC3560@balbir.in.ibm.com>
	 <20091104154024.0b8f6123.kamezawa.hiroyu@jp.fujitsu.com>
	 <20091104081618.GD3560@balbir.in.ibm.com>
	 <1257348117.31972.4360.camel@nimitz>  <20091104161142.GA8825@us.ibm.com>
Content-Type: text/plain
Date: Wed, 04 Nov 2009 08:20:23 -0800
Message-Id: <1257351623.31972.4421.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-11-04 at 10:11 -0600, Serge E. Hallyn wrote:
> If you do, then while I DETEST the extra typing, I think
> /sys/kernel/cgroup makes most sense, since that's where you find
> debugfs and securityfs.

Soon to be tracefs too.

-- Dave

