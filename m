Return-Path: <linux-kernel-owner+w=401wt.eu-S1753547AbZEaVME@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547AbZEaVME (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 17:12:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752217AbZEaVLy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 17:11:54 -0400
Received: from fmmailgate05.web.de ([217.72.192.243]:52724 "EHLO
	fmmailgate05.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057AbZEaVLy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 17:11:54 -0400
Date: Sun, 31 May 2009 23:11:54 +0200
Message-Id: <744614391@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: linux-kernel@vger.kernel.org
Subject: Re: Xen is a feature
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX1/23DRUwwPQmIii/aTyaD5BBTYo92YrKiZSrqE329EsP43j5
 d6rtpP1UtgIeInNSElfo61/ch5AMvuPQZA2fV66lml2vAF1gyY=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

can we have dom0 support in mainline please?

NOW!

i`m really curious that companies spending millions on xen and even so mainline merge still remains such a neverending story.

 




List:       linux-kernel
Subject:    Re: Xen is a feature
From:       Tomasz Chmielewski <mangoo () wpkg ! org>
Date:       2009-05-29 11:48:59
Message-ID: 4A1FCBAB.2030100 () wpkg ! org
[Download message RAW]

Greg KH wrote:

> On Thu, May 28, 2009 at 05:45:34PM -0700, Jeremy Fitzhardinge wrote:
>> Mozilla and Debian are hosted on Xen systems.
> 
> A tiny data point about these domains.  They are hosted by osuosl.org,
> which uses xen systems running with the current dom0 patch set.  Because
> those patches are out-of-tree, they have a hard time updating kernel
> versions, and generally lag kernel.org releases by a lot, which is not
> always a good thing.
> 
> So getting the dom0 patches into mainline will make their lives much
> easier, and more secure.

I know at least a couple of mid-sized hosting companies migrating all or 
part of their infrastructure off Linux/Xen to a proprietary solution, 
because of this very reason (problems with keeping dom0 kernel up to 
date, problems with deploying it on new machines etc.).

-- 
Tomasz Chmielewski
http://wpkg.org



_______________________________________________________________________
Nur bis 31.05.: WEB.DE FreeDSL Komplettanschluss mit DSL 6.000 Flatrate
und Telefonanschluss für 17,95 Euro/mtl.! http://produkte.web.de/go/02/

