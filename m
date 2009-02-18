Return-Path: <linux-kernel-owner+w=401wt.eu-S1753579AbZBRKxw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579AbZBRKxw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 05:53:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751950AbZBRKxn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 05:53:43 -0500
Received: from cluster-g.mailcontrol.com ([208.87.233.190]:45355 "EHLO
	cluster-g.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbZBRKxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 05:53:43 -0500
Message-ID: <499BE83D.6040406@csr.com>
Date: Wed, 18 Feb 2009 10:51:41 +0000
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Chas Williams <chas@cmf.nrl.navy.mil>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [patch 5/7] usb: use kzfree()
References: <20090217182615.897042724@cmpxchg.org> <20090217184136.097882343@cmpxchg.org>
In-Reply-To: <20090217184136.097882343@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Feb 2009 10:51:41.0702 (UTC) FILETIME=[E1E97A60:01C991B6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is in the WUSB code so:

Acked-by: David Vrabel <david.vrabel@csr.com>

David
-- 
David Vrabel, Senior Software Engineer, Drivers
CSR, Churchill House, Cambridge Business Park,  Tel: +44 (0)1223 692562
Cowley Road, Cambridge, CB4 0WZ                 http://www.csr.com/
