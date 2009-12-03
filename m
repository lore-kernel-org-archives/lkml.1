Return-Path: <linux-kernel-owner+w=401wt.eu-S1753682AbZLCLtm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682AbZLCLtm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 06:49:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752374AbZLCLtl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 06:49:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24573 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752044AbZLCLtk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 06:49:40 -0500
Date: Thu, 3 Dec 2009 06:49:14 -0500
From: Stefan Assmann <sassmann@redhat.com>
To: linux-pci@vger.kernel.org
Cc: jeff@garzik.org, linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
       rjw@sisk.pl, ddutile@redhat.com, kaneshige.kenji@jp.fujitsu.com,
       Stefan Assmann <sassmann@redhat.com>, khc@pm.waw.pl
Message-Id: <20091203114914.24905.67372.sendpatchset@localhost.localdomain>
Subject: [PATCH 0/2 v2] pci: change PCI nomenclature according to PCI-SIG
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

the following patch queue changes variants of PCI-X and PCIe to the terms
listed in the "Trademark and Logo Usage Guidelines".
http://www.pcisig.com/developers/procedures/logos/Trademark_and_Logo_Usage_Guidelines_updated_112206.pdf

Due to comments from Jeff Garzik and others changes are limited to drivers/pci/
for now and split up into comment changes and non-comment changes for easier
reviewing.
Patches are based on 2.6.32.

If this works out I'd like to follow up with patches for the individual
device drivers with the concerning maintainers in Cc.

  Stefan
--
Stefan Assmann         | Red Hat GmbH
Software Engineer      | Otto-Hahn-Strasse 20, 85609 Dornach
                       | HR: Amtsgericht Muenchen HRB 153243
                       | GF: Brendan Lane, Charlie Peters,
sassmann at redhat.com |     Michael Cunningham, Charles Cachera
