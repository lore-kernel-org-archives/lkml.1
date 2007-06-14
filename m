Return-Path: <linux-kernel-owner+w=401wt.eu-S1753245AbXFNSiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245AbXFNSiS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 14:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751162AbXFNSiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 14:38:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55512 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751102AbXFNSiD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 14:38:03 -0400
To: Paulo Marques <pmarques@grupopie.com>
Cc: Al Viro <viro@ftp.linux.org.uk>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Bernd Paysan <bernd.paysan@gmx.de>, Krzysztof Halasa <khc@pm.waw.pl>,
       linux-kernel@vger.kernel.org
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <466A3EC6.6030706@netone.net.tr>
	<200706141023.21624.bernd.paysan@gmx.de>
	<20070614153935.GO21478@ftp.linux.org.uk>
	<200706141832.58526.bernd.paysan@gmx.de>
	<20070614164124.GP21478@ftp.linux.org.uk>
	<d120d5000706141001o2d00f20cqb4133bf7b9ba11ab@mail.gmail.com>
	<20070614170902.GQ21478@ftp.linux.org.uk>
	<467178D3.6010204@grupopie.com>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Thu, 14 Jun 2007 15:37:20 -0300
In-Reply-To: <467178D3.6010204@grupopie.com> (Paulo Marques's message of "Thu\, 14 Jun 2007 18\:20\:19 +0100")
Message-ID: <or4plae61r.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 14, 2007, Paulo Marques <pmarques@grupopie.com> wrote:

> $ find -name "*.c" | xargs grep "any later version" | wc -l
> 3138
> $ find -name "*.c" | wc -l
> 9482

How many of these don't mention version 2?

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
