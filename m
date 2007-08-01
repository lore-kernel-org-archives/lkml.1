Return-Path: <linux-kernel-owner+w=401wt.eu-S934048AbXHAPBg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934048AbXHAPBg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 11:01:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933856AbXHAPAz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 11:00:55 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:43262 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933843AbXHAPAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 11:00:53 -0400
X-Sasl-enc: arNQ8B4b+Qw4ftVROYSdWcZ2+0wHQQxGqIIedhzaPSyS 1185980452
Date: Wed, 1 Aug 2007 12:00:49 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
Cc: Hugh Dickins <hugh@veritas.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       len.brown@intel.com, linux-acpi@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, mingo@redhat.com,
       linux-pm@linux-foundation.org,
       Borislav Deianov <borislav@users.sourceforge.net>
Subject: Re: 2.6.21-rc1: T60 ACPI issues
Message-ID: <20070801150049.GH23111@khazad-dum.debian.net>
References: <20070801135820.GA8266@mellanox.co.il> <Pine.LNX.4.64.0708011516540.15447@blonde.wat.veritas.com> <20070801145607.GB8480@mellanox.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070801145607.GB8480@mellanox.co.il>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 01 Aug 2007, Michael S. Tsirkin wrote:
> Henrique, if there's a patch to test, pls let me know.
> Or maybe CONFIG_THINKPAD_ACPI_INPUT_ENABLED should be N by default.

I will hunt down the LKML mail and reply to it.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
