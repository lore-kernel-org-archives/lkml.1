Return-Path: <linux-kernel-owner+w=401wt.eu-S1030218AbXBLWic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030218AbXBLWic (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 17:38:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030217AbXBLWic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 17:38:32 -0500
Received: from mail1.webmaster.com ([216.152.64.169]:3714 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030216AbXBLWia convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 17:38:30 -0500
From: "David Schwartz" <davids@webmaster.com>
To: <helge.hafting@aitel.hist.no>
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] Ban module license tag string termination trick
Date: Mon, 12 Feb 2007 14:37:50 -0800
Message-ID: <MDEHLPKNGKAHNMBLJOLKOENDBIAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <45D08CC0.30403@aitel.hist.no>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Mon, 12 Feb 2007 14:38:04 -0800
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Mon, 12 Feb 2007 14:38:05 -0800
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> David Schwartz wrote:

> >> Indeed, but using the provided key is not circumventing. Loading a
> >> non-GPL module that uses GPL symbols anyway is prevented, so
> >> forcibly loading such a module "the rootkit way" by patching /dev/mem
> >> is a circumvention. Catch one of the script kiddies inside the US, and 
> >> you can
> >> theoretically nail him with the DMCA these days.

> > The greater has to include the lesser. If you have the 
> > authority to remove or modify a copyright enforcement scheme, you 
> > cannot be circumventing it.

> I have a key to my office door that I am authorized to use.
> That don't mean it is ok for me to circumvent the lock with a crowbar too.

Right, I'm not arging that the lesser includes the greater but that the greater includes the lesser. If you are authorized to remove the door, you can certainly open it with the key. If you don't have the key, and you are authorized to remove the door, you can certainly circumvent it with a crowbar in order to remove it.

Authorization to remove a security mechanism entirely makes it impossible to circumvent it. There is nothing you are not allowed to do that the security mechanism stops you from doing.
 
> > In any event, if your argument were correct, the Linux kernel 
> > would not be distributable. The license enforcement scheme in the 
> > kernel makes it unlawful to modify the modules in a particular 
> > way, and they are both distributed under the GPL. This would be a 
> > "further restriction" since the restriction is not found in the 
> > GPL itself.

> No, it is not a licence restriction.  It is a law.  Modifying the
> kernel to send holocaust-denying messages (or other illegal
> stuff like printing money) is illegal too, but not an
> additional restriction. 

Patents are not license restrictions either. The GPL is really clear, if a law restricts GPL rights, you have to modify the program so that the law doesn't apply. Otherwise, you can't distribute it.

There will always be laws that impose some restrictions on what you can do with software. You cannot modify the kernel to send death threats to elected officials of various governments. I don't think it's meaningful to compare this to a scheme specifically designed to invoke a law to make it difficult to do specific things that would otherwise not be difficult.

> >> Just as using your door key does not circumvent the door lock even
> >> though you open it.

> > And neither is breaking down your own door. If you have the 
> > right to remove the door, you have the right to break it down. 
> > The greater includes the lesser.

> Nope.  I am authorized to open and enter many doors that I don't own.
> I have no right to open them by other means, just as I have
> no right to relicence the linux kernel even if I may modify & 
> redistribute it.

You are showing an example where the lesser doesn't include the greater. Nobody is arguing that. I am arguing the greater includes the lesser. If you have the right to *remove* a door, you can pick the lock to get to the hinges.

If you are authorized to remove a security system, you cannot circumvent it.
 
> > That's simply not true. It makes some proprietary modules 
> > unusable on mainstream kernels, thus decreasing the value of them 
> > if they're distributed. This is exactly what many anti-copying schemes do.

> Copying is only "prevented" by reducing the incentive.  Any copies
> made & distributed are still legal copies.  Not so with a copy of a DVD.
> The value of the modules might decrease because they are useless, but
> that is ok.  The modules wasn't GPLed anyway - only the kernel.

All DRM schemes just reduce the value of the copy. Some of the copies made might still be legal. That doesn't change anything.
 
> > How is this scheme (which makes mainstream kernels unable to 
> > work with modules that are not GPL-licensed) different from the 
> > DVD scheme (that makes unlicensed players unable to play 
> > mainstream DVDs)? Engineered incompatability restricts the 
> > distribution value of the items made incompatible.

> There is the difference that copying the DVD is illegal anyway - 
> it doesn't
> matter if you bypass copy-protection or not.  (You can trivially copy
> a DVD without breaking the encryption - you can then sell
> it on the black market to people who have working DVD players.)

No, no no. The whole point of these schemes is they affect legal copies as well. These schemes have no way to determine whether a particular copy is lawful or unlawful.

For example, suppose I download some music with DRM onto a USB flash key. I pay for the song, and the copy on the USB key is my only copy. If I take the key to another machine where I don't have any licenses, my breaking the DRM scheme to play the song is still circumvention. It has nothing whatsoever to do with the legal status of the copy.

> You can legally copy the kernel though.  Or modify it.

You can legally copy or modify any work, under the right circumstances. The whole point of copyright enforcement schemes is that they don't care what's legal. No law prevents you from loading non-GPL'd modules into the kernel (assuming you don't distribute them).

> Defeating the protection while it is up and running is what might
> be illegal.  It is unusual that you are actually allowed to remove the
> scheme by a patch.  I assume this don't change how the DMCA works,
> bit of course this will depend on the exact wording.
> Using your provided key is not circumventing - smashing the lock is.

We are not talking about using a provided key but removing the lock entirely. If you can remove it, you can smash it if that's the best way to get it out of the way. The greater includes the lesser.
 
> What if you buy a copy of windows, then binary patch the install DVD
> so it don't ask for the registration code, then install it on your own
> PC (without redistributing the cracked DVD?)
> The end result is no different from a normal install, you paid for the 
> software,
> you didn't circulate any cracks.  You just prefer this way of installing
> rather than typing in lots of numbers from a piece of paper. Perhaps
> it really is easier - with some highly automated cracking software.
> 
> It is legal here where the DMCA doesn't apply - How about the U.S.?

I think it's not clear as far as the DMCA goes. It would certainly be an EULA violation though. Whether there'd be any damages, though, is another question.
 
> > If you choose the GPL, you lose the right to "make it harder" 
> > for people to distribute and modify code. The GPL sets the terms 
> > and is carefully constructed so that nobody can later change them.

> And this scheme doesn't make it harder to distribute and modify
> kernel code.  It might make it harder to get a closed-source
> module working, or to make it work without the GPL symbols
> it really would like to use.

It does make it harder to distribute and modify GPL'd modules though. For example, if you remove the 'GPL' license tag, they will refuse to load. And do not even try to claim this is a license notice the GPL prohibits you from removing. It is *functional* *code*. If you could make functional code that's also a license notice, you could totally bypass the GPL's requirements recipients be free to modify.

Now there's nothing inherently wrong with this. Any module loading sanity check in the kernel makes it harder to distibute and modify a GPL'd module that fails that sanity check. That can't mean that sanity checks somehow violate the GPL.

However, a "sanity check" that takes advantage of a *law*, rather than purely technical means, is another story. Then it's a deliberate invocation of a law to make the work harder to distribute and modify, and that's what the GPL prohibits. (This is no different from a patent that makes a work harder to distribute.)

> Many changes in the kernel makes it harder to make things work,
> the kernel is getting bigger and more complicated all the time.
> "Hardness" can't possibly matter.  A more complicated (but also
> more efficient) VM makes it harder to make a useful patch. Only
> the useless ones are as easy as always.

Read the last part of paragraph 7. Here the GPL uses the example about a legal process that has the effect of making the kernel harder to distribute. It demands that you refrain from distributing at all in this case.
 
> > This is precisely the type of thing the GPL was designed to 
> > prohibit. You are not supposed to be able to abuse copyright to 
> > retain control over a GPL'd work.

> I always had the impression that the GPL was made to prevent
> closed distribution of something that started out free.  So you
> can't add non-gpl stuff into the kernel, or distribute
> binary while holding back source.

Yes, that is what the GPL was made to prevent. However, this scheme tries to force even code that is not distributed to be placed under the GPL.
 
> This copyright enforcement scheme don't prevent any of that,
> precisely because it can be removed from the _source_ legally.
> Tampering with it while it runs might be illegal some places,
> just as printing certain strings might be illegal.

The analogy doesn't work for two reasons. First, nobody has done anything deliberate to make this "printing certain strings" restrict your ability to modify a particular work. Second, it conflates a positive with a negative. Your example is of specific things you can't do in any context which is not the same as specific things you must do in just this context.
 
> Closed modules are allowed only because an exception was made
> in the licencing.  That didn't have to happen at all.  Closed modules
> only get a limited interface, so that they won't be derived works.

I do not believe that this is the case. Closed modules are allowed because there is no legal authority to prevent them.

> Circumventing that creates a non-GPL derived work - which is illegal
> to redistribute regardless of protection schemes. 

This is cleverly worded to hide the basic disconnect -- this change makes it harder to develop and use code which is illegal to dedistribute, but *not* illegal to develop and use.

> The sceme just makes this harder
> to do for those who wish to try anyway.

Nothing wrong with trying to develop code that can't be distributed. Or are you saying there's something wrong with this?!

> The DMCA might be
> useable for making it even harder.  An interesting irony - turning the
> DMCA against the sort of people who wanted it in the first place.

Right, the people who want to develop modules they have no intent to distribute in the privacy of their own home.
 
> DMCA or not - copyrigth law prevents distributing a closed derived work.
> Unfortunately, that don't stop people from trying - it is hard to
> see what's going on in a closed module.  Now if breaking the law
> this way can be made more difficult then that is a good thing.  Fewer
> vendors will then try.  They will make closed modules hampered by
> no access to GPL symbols - or open-source modules, or none at all.

Right, use copyright law to make it more difficult to develop and use certain works because it's illegal to distribute them. That sounds like the spirit of the GPL to me.

GPL advocates should be arguing that you can modify works you own to make them more useful to you however you want, not that copyright law should be twisted to make such modifications difficult or illegal.

Reality check -- this particular scheme has *nothing* to do with distribution and treats code that has not been distributed the same as code that has been.

DS


