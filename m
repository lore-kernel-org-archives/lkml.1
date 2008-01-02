Return-Path: <linux-kernel-owner+w=401wt.eu-S1754598AbYABODy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598AbYABODy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 09:03:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752518AbYABODr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 09:03:47 -0500
Received: from fmmailgate04.web.de ([217.72.192.242]:34820 "EHLO
	fmmailgate04.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291AbYABODq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 09:03:46 -0500
Date: Wed, 02 Jan 2008 15:03:44 +0100
Message-Id: <81671269@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [BUG] crash - module radio-sf16fmr2 and esp interfere
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX1+eThfCEjIFrpisApJQ1RFqphwGHld7FGIWJC6a2W0ykbOBR
 0M8wHyuEUUjy3NoW/gn+qpyR2smypxGAsBPt0E5KY9zBvv5hhE=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > same with radio-sf16fmr2 and esp
> > 
> > after repeatedly modrpobe/modprobe -r  radio-sf16fmr2,  i can hang my system when loading esp afterwards
> > 
> > before loading esp, doing a "cat /proc/ioport" segfaults
> > 
> > this is with 2.6.24rc6 and also with 2.6.22
> > 
> > i have found these issues by running some (probably sick :D )  module load/unload test across all modules 
> > 
> 
> Hi,
> Please provide more kernel crash info, as listed in the
> REPORTING-BUGS file in the top-level directory of the kernel
> source tree.

thanks for the pointer, i will mind that in the future.


__________________________________________________________________________
Erweitern Sie FreeMail zu einem noch leistungsstärkeren E-Mail-Postfach!		
Mehr Infos unter http://produkte.web.de/club/?mc=021131

