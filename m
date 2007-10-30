Return-Path: <linux-kernel-owner+w=401wt.eu-S1755408AbXJ3PBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408AbXJ3PBp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 11:01:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753056AbXJ3PBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 11:01:36 -0400
Received: from web36613.mail.mud.yahoo.com ([209.191.85.30]:29388 "HELO
	web36613.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752296AbXJ3PBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 11:01:35 -0400
X-YMail-OSG: PMjzriAVM1kQV_ZRydxKra8.CY9uylG2Ch2navGv.K0Jz65VvbkvK6s3NAhJksY3EZ4CMeG4fg--
X-RocketYMMF: rancidfat
Date: Tue, 30 Oct 2007 08:01:31 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: Defense in depth: LSM *modules*, not a static interface
To: Crispin Cowan <crispin@crispincowan.com>, Al Viro <viro@ftp.linux.org.uk>
Cc: Cliffe <cliffe@ii.net>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
In-Reply-To: <4726E36F.6030909@crispincowan.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <697420.13474.qm@web36613.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Crispin Cowan <crispin@crispincowan.com> wrote:

> Al Viro wrote:
> > On Tue, Oct 30, 2007 at 03:14:33PM +0800, Cliffe wrote:
> >   
> >> Defense in depth has long been recognised as an important secure design 
> >> principle. Security is best achieved using a layered approach.
> >>     
> >  "Layered approach" is not a magic incantation to excuse any bit of snake
> > oil.  Homeopathic remedies might not harm (pure water is pure water),
> > but that's not an excuse for quackery.  And frankly, most of the
> > "security improvement" crowd sound exactly like woo-peddlers.
> >   
> Frank's point was that the static interface makes layering somewhere
> between impractical and impossible. The static interface change should
> be dumped so that layering is at least possible. Whether any given
> security module is worth while is a separate issue.
> 
> I.e. that there are bad medicines around is a poor excuse to ban
> syringes and demand that everyone be born with a strong immune system.
> 
> Why is it that security flame wars always end up reasoning with absurd
> analogies? :-)

That's my fault, sorry. I don't know why it's my fault,
but that's where it usually ends up and I thought I'd get
the blame bit out of the way. Gotta go squeeze some legless
reptiles now.


Casey Schaufler
casey@schaufler-ca.com
