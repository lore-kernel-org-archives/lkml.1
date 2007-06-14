Return-Path: <linux-kernel-owner+w=401wt.eu-S1752176AbXFNNhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176AbXFNNhU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 09:37:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751304AbXFNNhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 09:37:09 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:33748
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751162AbXFNNhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 09:37:07 -0400
Date: Thu, 14 Jun 2007 15:38:26 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: Vitez Gabor <vitezg@niif.hu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: heartbeat problems on linux 2.6.21.[34]
Message-ID: <20070614133826.GC21005@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	Vitez Gabor <vitezg@niif.hu>, linux-kernel@vger.kernel.org
References: <20070614125203.GV20208@swszl.szkp.uni-miskolc.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070614125203.GV20208@swszl.szkp.uni-miskolc.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

El Thu, Jun 14, 2007 at 02:52:03PM +0200 Vitez Gabor ha dit:
 
> I'm running debian etch in linux 2.6.21.[34], and ran into troubles with
> heartbeat:
> 
> In some cases, I get "
> Jun 12 13:14:36 sf1 heartbeat[2973]: ERROR: No local heartbeat. Forcing restart.
> Jun 12 13:14:36 sf1 heartbeat[2973]: WARN: Late heartbeat: Node sf1: interval 42740 ms
> 
> "
> 
> The heartbeat configuration files were copied from another debian machine,
> running 2.6.18-3-xen-686 stock debian kernel, with no problems. 
> 
> 
> 
> The machine is not loaded, I'm just testing heartbeat on it.

you're writing to the wrong list, your problem seems to be a
*heartbeat* issue and not a *kernel* one

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

    Yo soy como soy y tú eres como eres, construyamos un mundo donde yo
    pueda ser sin dejar de ser yo, donde tú puedas ser sin dejar de ser
    tú, y donde ni yo ni tú obliguemos al otro a ser como yo o como tú
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
