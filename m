Return-Path: <linux-kernel-owner+w=401wt.eu-S1755390AbXFNRqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390AbXFNRqa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 13:46:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752754AbXFNRpt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 13:45:49 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:39490 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752572AbXFNRps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 13:45:48 -0400
X-Sasl-enc: 5xA99Kak/Vpxb8Qw8OuWlOysy9NV55s6mhAcxxjuxH/8 1181843147
Date: Thu, 14 Jun 2007 14:45:40 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Greg KH <greg@kroah.com>
Cc: Chuck Ebbert <cebbert@redhat.com>, linux-stable <stable@kernel.org>,
       Dave Jones <davej@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, dsd@gentoo.org
Subject: Re: [stable]  libata spindown patches for 2.6.21-stable
Message-ID: <20070614174540.GB358@khazad-dum.debian.net>
References: <4671664A.8010404@redhat.com> <20070614173051.GA9039@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070614173051.GA9039@kroah.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jun 2007, Greg KH wrote:
> Are there reported bugs that this patchset fixes?

Yes, at least one I opened and which got a CODE_FIX when Tejun prepared the
first version of the patch.

http://bugzilla.kernel.org/show_bug.cgi?id=7838

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
