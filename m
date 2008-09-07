Return-Path: <linux-kernel-owner+w=401wt.eu-S1755881AbYIGWjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755881AbYIGWjX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 18:39:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753186AbYIGWjO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 18:39:14 -0400
Received: from gw.goop.org ([64.81.55.164]:55264 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752705AbYIGWjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 18:39:13 -0400
Message-ID: <48C4580F.4000804@goop.org>
Date: Sun, 07 Sep 2008 15:39:11 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Tomas Carnecky <tom@dbservice.com>
CC: Steven King <sfking@fdwdc.com>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Zhang Rui <rui.zhang@intel.com>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, ibm-acpi-devel@lists.sourceforge.net
Subject: Re: 2.6.26.[1-3] + x61 tablet + x6ultrabase: no resume	after?undocking
References: <200808301535.22419.sfking@fdwdc.com> <20080901112816.GA21970@khazad-dum.debian.net> <48BBDD2C.5020804@dbservice.com> <200809011205.05253.sfking@fdwdc.com> <20080903144541.GA10978@homac> <48BEA77A.5050104@dbservice.com>
In-Reply-To: <48BEA77A.5050104@dbservice.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tomas Carnecky wrote:
> I don't know whether I should ROFL or be sad, but: In the 2.6.26 stable
> tree the bay driver (ACPI_BAY) is marked as EXPERIMENTAL, and now you're
> saying that it's obsolete. Do features go right from experimental to
> obsolete now?

Sure.  Some experiments don't work out.

    J

