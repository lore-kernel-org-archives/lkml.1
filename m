Return-Path: <linux-kernel-owner+w=401wt.eu-S1767009AbXDSUTK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767009AbXDSUTK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 16:19:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767024AbXDSUTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 16:19:10 -0400
Received: from mail6.sea5.speakeasy.net ([69.17.117.8]:42332 "EHLO
	mail6.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767009AbXDSUTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 16:19:09 -0400
Date: Thu, 19 Apr 2007 16:19:05 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: Bernd Eckenfels <ecki@lina.inka.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: AppArmor FAQ
In-Reply-To: <E1HebEV-0004m9-00@calista.eckenfels.net>
Message-ID: <Line.LNX.4.64.0704191618360.5128@d.namei>
References: <E1HebEV-0004m9-00@calista.eckenfels.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Apr 2007, Bernd Eckenfels wrote:

> In article <Line.LNX.4.64.0704180935100.25495@d.namei> you wrote:
> > Perhaps -- until your httpd is compromised via a buffer overflow or 
> > simply misbehaves due to a software or configuration flaw, then the 
> > assumptions being made about its use of pathnames and their security 
> > properties are out the window.
> 
> Hu? Even a compromised httpd (especially a compromised httpd) is bound to
> the app armor policies. This means it cannot (for example) write to
> /var/www/* - if it never needed to at normal/profiling time.

This has been addressed several times already, please read the full 
thread.



- James
-- 
James Morris
<jmorris@namei.org>
