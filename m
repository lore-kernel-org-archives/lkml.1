Return-Path: <linux-kernel-owner+w=401wt.eu-S1760656AbXEYJXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760656AbXEYJXV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 05:23:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760648AbXEYJXB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 05:23:01 -0400
Received: from antispam.upcomillas.es ([130.206.70.245]:39806 "EHLO
	antispam.upcomillas.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761601AbXEYJW7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 05:22:59 -0400
Subject: Re: Long delay in resume from RAM (Was Re: [patch 
	00/69]-stablereview)
From: Romano Giannetti <romanol@upcomillas.es>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.0.98.0705241549130.26602@woody.linux-foundation.org
	>
References: <20070521191612.800400000@sous-sol.org> 
	<4652070D.3090509@redhat.com> 
	<alpine.LFD.0.98.0705211406000.3890@woody.linux-foundation.org> 
	<20070521212522.GL3429@sequoia.sous-sol.org> 
	<1179870110.16656.2.camel@localhost> 
	<alpine.LFD.0.98.0705221452290.3890@woody.linux-foundation.org> 
	<1180008394.15600.26.camel@localhost> <1180019201.15600.57.camel@localhost>
	 <alpine.LFD.0.98.0705240815530.26602@woody.linux-foundation.org> 
	<1180044888.15241.39.camel@localhost> 
	<alpine.LFD.0.98.0705241549130.26602@woody.linux-foundation.org>
Content-Type: text/plain;
	charset=utf-8
Date: Fri, 25 May 2007 11:22:56 +0200
Message-Id: <1180084976.31495.15.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-24 at 15:49 -0700, Linus Torvalds wrote:
>

> It really would be nice of you to just "git bisect" this, to see where it
> started having that 60-second delay..

...and while at it, I decided to start by learning a bit more of git,
and installed the last version...

% git clone http://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git linux-2.6
Initialized empty Git repository in /usr/src/git/linux-2.6/.git/
Cannot get remote repository information.
Perhaps git-update-server-info needs to be run there?

I cannot use git protocol from here (overfirewalling, you know...)

Romano

--
Romano Giannetti --- romano.giannetti@gmail.com
Sorry for the following disclaimer, it's attached by our otugoing server
and I cannot shut it up.



--
La presente comunicación tiene carácter confidencial y es para el exclusivo uso del destinatario indicado en la misma. Si Ud. no es el destinatario indicado, le informamos que cualquier forma de distribución, reproducción o uso de esta comunicación y/o de la información contenida en la misma están estrictamente prohibidos por la ley. Si Ud. ha recibido esta comunicación por error, por favor, notifíquelo inmediatamente al remitente contestando a este mensaje y proceda a continuación a destruirlo. Gracias por su colaboración.

This communication contains confidential information. It is for the exclusive use of the intended addressee. If you are not the intended addressee, please note that any form of distribution, copying or use of this communication or the information in it is strictly prohibited by law. If you have received this communication in error, please immediately notify the sender by reply e-mail and destroy this message. Thank you for your cooperation.

