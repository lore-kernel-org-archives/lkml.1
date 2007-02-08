Return-Path: <linux-kernel-owner+w=401wt.eu-S933331AbXBHAWM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933331AbXBHAWM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 19:22:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422829AbXBHAWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 19:22:11 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:57068 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422828AbXBHAWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 19:22:10 -0500
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
       jejb <james.bottomley@steeleye.com>
Subject: Re: [patch] Re: SCSI logging sucks
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <45CA0716.5060803@redhat.com>
	<20070207153530.70412bc3.randy.dunlap@oracle.com>
Date: Wed, 07 Feb 2007 19:20:42 -0500
In-Reply-To: <20070207153530.70412bc3.randy.dunlap@oracle.com> (Randy Dunlap's message of "Wed, 7 Feb 2007 15:35:30 -0800")
Message-ID: <yq17iut7b51.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Randy" == Randy Dunlap <randy.dunlap@oracle.com> writes:

Randy> There are a number of things that can be used for 'token' (you
Randy> can find them in the source: <file:drivers/scsi/scsi.c>), and
Randy> this allows you to select the types of information you want,
Randy> and the level allows you to select the level of verbosity.  """

There's a very convenient script called scsi_logging_level included in
(of all things) the s390-tools package.

Maybe provide a pointer to it -- or even just include it.  It's not
very big...

http://www-128.ibm.com/developerworks/linux/linux390/s390-tools-1.5.4.html

-- 
Martin K. Petersen	Oracle Linux Engineering

