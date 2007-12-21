Return-Path: <linux-kernel-owner+w=401wt.eu-S1757430AbXLUFjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757430AbXLUFjY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 00:39:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750818AbXLUFjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 00:39:17 -0500
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:37816 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbXLUFjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 00:39:16 -0500
Subject: Re: iommu dma mapping alignment requirements
From: Benjamin Herrenschmidt <benh@au1.ibm.com>
Reply-To: benh@au1.ibm.com
To: Steve Wise <swise@opengridcomputing.com>
Cc: benh@ozlabs.au.ibm.com, Roland Dreier <rdreier@cisco.com>,
       linux-kernel@vger.kernel.org,
       OpenFabrics General <general@lists.openfabrics.org>,
       Benjamin Herrenschmidt <bherren@au1.ibm.com>,
       Wen Xiong <wenxiong@us.ibm.com>, Olof Johansson <olof@lixom.net>,
       Paul Mackerras <pmac@au1.ibm.com>
In-Reply-To: <476B45E9.1040909@opengridcomputing.com>
References: <476AA2E2.5010007@opengridcomputing.com>
	 <1198181862.6779.3.camel@pasglop> <476AD84E.4000507@opengridcomputing.com>
	 <1198186017.6779.28.camel@pasglop> <476AE8C9.9080601@opengridcomputing.com>
	 <1198194585.6779.31.camel@pasglop> <476B45E9.1040909@opengridcomputing.com>
Content-Type: text/plain
Organization: IBM Ozlabs
Date: Fri, 21 Dec 2007 16:38:31 +1100
Message-Id: <1198215511.6779.51.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BTW. I need to know urgently what HW is broken by this 

Ben.


