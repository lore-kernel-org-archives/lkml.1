Return-Path: <linux-kernel-owner+w=401wt.eu-S1756039AbZKEI0J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039AbZKEI0J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 03:26:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753601AbZKEI0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 03:26:09 -0500
Received: from boogie.lpds.sztaki.hu ([193.224.70.237]:48489 "EHLO
	boogie.lpds.sztaki.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753538AbZKEI0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 03:26:08 -0500
Date: Thu, 5 Nov 2009 09:26:12 +0100
From: Gabor Gombas <gombasg@sztaki.hu>
To: Jan Safranek <jsafrane@redhat.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>, balbir@linux.vnet.ibm.com,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       containers@lists.linux-foundation.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Bharata B Rao <bharata.rao@in.ibm.com>,
       libcg-devel <libcg-devel@lists.sourceforge.net>,
       "menage@google.com" <menage@google.com>
Subject: Re: [RFC] Mount point suggestions for cgroup
Message-ID: <20091105082612.GE24467@boogie.lpds.sztaki.hu>
References: <20091104063005.GC3560@balbir.in.ibm.com>
 <20091104154024.0b8f6123.kamezawa.hiroyu@jp.fujitsu.com>
 <20091104081618.GD3560@balbir.in.ibm.com>
 <1257348117.31972.4360.camel@nimitz>
 <20091104161142.GA8825@us.ibm.com>
 <4AF1AACE.6060705@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AF1AACE.6060705@redhat.com>
X-Copyright: Forwarding or publishing without permission is prohibited.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 04, 2009 at 05:24:46PM +0100, Jan Safranek wrote:

> LSB (and FHS) IMHO does not specify any place for such stuff:
> 
> /dev - for devices only, cgroups are not devices

The FHS says the following for /dev on Linux:

	/dev : Devices and special files

IMHO cgroups are covered by "special files".

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
