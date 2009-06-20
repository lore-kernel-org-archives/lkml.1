Return-Path: <linux-kernel-owner+w=401wt.eu-S1753500AbZFTM4M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500AbZFTM4M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 08:56:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751980AbZFTMz6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 08:55:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:47228 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751590AbZFTMz5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 08:55:57 -0400
Subject: Re: [PATCH] gitignore scripts/ihex2fw
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090620124240.GA692@uranus.ravnborg.org>
References: <1245228117.2662.2.camel@ht.satnam>
	 <20090620124240.GA692@uranus.ravnborg.org>
Content-Type: text/plain
Date: Sat, 20 Jun 2009 18:25:25 +0530
Message-Id: <1245502525.3042.0.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-06-20 at 14:42 +0200, Sam Ravnborg wrote:
> On Wed, Jun 17, 2009 at 02:11:57PM +0530, Jaswinder Singh Rajput wrote:
> > 
> > scripts/ihex2fw is a binary file is suitable candidate for ignore
> > 
> > Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> > ---
> >  .gitignore |    3 +++
> >  1 files changed, 3 insertions(+), 0 deletions(-)
> > 
> > diff --git a/.gitignore b/.gitignore
> > index cecb3b0..cdfb7ce 100644
> > --- a/.gitignore
> > +++ b/.gitignore
> 
> Why not scripts/.gitignore?

[PATCH] gitignore scripts/ihex2fw

scripts/ihex2fw is a binary files should be ignored

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 scripts/.gitignore |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/scripts/.gitignore b/scripts/.gitignore
index b939fbd..52cab46 100644
--- a/scripts/.gitignore
+++ b/scripts/.gitignore
@@ -7,3 +7,4 @@ pnmtologo
 bin2c
 unifdef
 binoffset
+ihex2fw
-- 
1.6.0.6



