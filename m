Return-Path: <linux-kernel-owner+w=401wt.eu-S1422704AbXBURGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422704AbXBURGA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 12:06:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422702AbXBURGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 12:06:00 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:39557 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422699AbXBURF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 12:05:58 -0500
Subject: Re: [PATCH] ehea: dynamic add / remove port
From: John Rose <johnrose@austin.ibm.com>
To: Jan-Bernd Themann <ossthema@de.ibm.com>
Cc: Jeff Garzik <jeff@garzik.org>, Christoph Raisch <RAISCH@de.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ppc <linuxppc-dev@ozlabs.org>, Marcus Eder <MEDER@de.ibm.com>,
       Thomas Klein <tklein@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>,
       netdev <netdev@vger.kernel.org>
In-Reply-To: <200702211706.18235.ossthema@de.ibm.com>
References: <200702211706.18235.ossthema@de.ibm.com>
Content-Type: text/plain
Message-Id: <1172077378.22669.15.camel@sinatra.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Ximian Evolution 1.4.6 (1.4.6-2) 
Date: Wed, 21 Feb 2007 11:02:58 -0600
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-02-21 at 10:06, Jan-Bernd Themann wrote:
> This patch introduces functionality to dynamically add / remove
> ehea ports via an userspace DLPAR tool. It creates a subnode for
> each logical port in the sysfs. 

Looks great!

Signed-off-by: Jan-Bernd Themann <themann@de.ibm.com>
Acked-by: John Rose <johnrose@austin.ibm.com>


