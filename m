Return-Path: <linux-kernel-owner+w=401wt.eu-S1759628AbYBEPqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759628AbYBEPqh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 10:46:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759428AbYBEPpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 10:45:46 -0500
Received: from mtagate5.de.ibm.com ([195.212.29.154]:63251 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759423AbYBEPpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 10:45:42 -0500
Subject: Re: [patch 18/18] dcss: Initialize workqueue before using it.
From: Carsten Otte <cotte@de.ibm.com>
To: mschwid2@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       Gerald Schaefer <geraldsc@de.ibm.com>, heicars2@linux.vnet.ibm.com
In-Reply-To: <20080205153916.234022436@de.ibm.com>
References: <20080205153835.337897404@de.ibm.com>
	 <20080205153916.234022436@de.ibm.com>
Content-Type: text/plain
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
	Aufsichtsrats: Johann Weihen =?ISO-8859-1?Q?Gesch=E4ftsf=FChrung=3A?=
	Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-1?Q?B=F6blingen?=
	Registergericht: Amtsgericht Stuttgart, HRB 243294
Date: Tue, 05 Feb 2008 16:45:39 +0100
Message-Id: <1202226340.7780.0.camel@cotte.boeblingen.de.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, den 05.02.2008, 16:38 +0100 schrieb
mschwid2@linux.vnet.ibm.com:
> From: Heiko Carstens <heiko.carstens@de.ibm.com>

> Cc: Gerald Schaefer <geraldsc@de.ibm.com>
> Cc: Carsten Otte <cotte@de.ibm.com>
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Acked-by: Carsten Otte <cotte@de.ibm.com>

